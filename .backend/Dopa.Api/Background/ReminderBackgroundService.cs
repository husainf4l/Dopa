using Dopa.Api.Configurations;
using Dopa.Api.Data;
using Dopa.Api.Notifications;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Dopa.Api.Background;

public class ReminderBackgroundService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<ReminderBackgroundService> _logger;
    private readonly ReminderOptions _options;

    public ReminderBackgroundService(IServiceProvider serviceProvider, ILogger<ReminderBackgroundService> logger, IOptions<ReminderOptions> options)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
        _options = options.Value;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await ProcessRemindersAsync(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Reminder processing failed");
            }

            await Task.Delay(TimeSpan.FromSeconds(_options.PollingIntervalSeconds), stoppingToken);
        }
    }

    private async Task ProcessRemindersAsync(CancellationToken token)
    {
        using var scope = _serviceProvider.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        var sender = scope.ServiceProvider.GetRequiredService<INotificationSender>();

        var now = DateTime.UtcNow;
        var medThreshold = now.AddMinutes(_options.MedicationLeadMinutes);
        var apptThreshold = now.AddMinutes(_options.AppointmentLeadMinutes);
        var vaccineThreshold = now.AddHours(_options.VaccineLeadHours);

        var pendingMedReminders = await db.MedicationReminders
            .Include(r => r.Medication)!.ThenInclude(m => m!.User)
            .Where(r => !r.IsSent && r.ReminderTime <= medThreshold)
            .ToListAsync(token);

        foreach (var reminder in pendingMedReminders)
        {
            var title = $"Medication: {reminder.Medication?.Name}";
            var body = $"Time to take {reminder.Medication?.Dosage}";
            await sender.SendAsync(title, body, reminder.Medication?.User?.DeviceToken);
            reminder.IsSent = true;
        }

        var appointments = await db.Appointments
            .Include(a => a.User)
            .Where(a => a.AppointmentDate <= apptThreshold && a.AppointmentDate >= now)
            .ToListAsync(token);

        foreach (var appointment in appointments)
        {
            var title = "Upcoming appointment";
            var body = $"Dr. {appointment.DoctorName} at {appointment.Location}";
            await sender.SendAsync(title, body, appointment.User?.DeviceToken);
        }

        var vaccines = await db.VaccineDoses
            .Include(v => v.User)
            .Where(v => v.ScheduledDate <= vaccineThreshold && v.CompletedDate == null)
            .ToListAsync(token);

        foreach (var vaccine in vaccines)
        {
            await sender.SendAsync("Vaccine reminder", $"{vaccine.VaccineName} dose {vaccine.DoseNumber} due soon", vaccine.User?.DeviceToken);
        }

        await db.SaveChangesAsync(token);
    }
}
