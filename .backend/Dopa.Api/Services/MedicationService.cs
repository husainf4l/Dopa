using AutoMapper;
using AutoMapper.QueryableExtensions;
using Dopa.Api.Data;
using Dopa.Api.Dtos;
using Dopa.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Dopa.Api.Services;

public class MedicationService : IMedicationService
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;

    public MedicationService(AppDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }

    public async Task<IEnumerable<MedicationDto>> GetAsync(Guid userId)
    {
        return await _db.Medications
            .Where(x => x.UserId == userId)
            .Include(x => x.Reminders)
            .ProjectTo<MedicationDto>(_mapper.ConfigurationProvider)
            .ToListAsync();
    }

    public async Task<MedicationDto?> GetByIdAsync(Guid userId, Guid medicationId)
    {
        return await _db.Medications
            .Where(x => x.UserId == userId && x.Id == medicationId)
            .Include(x => x.Reminders)
            .ProjectTo<MedicationDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync();
    }

    public async Task<MedicationDto> CreateAsync(Guid userId, CreateMedicationRequest request)
    {
        var entity = new Medication
        {
            UserId = userId,
            Name = request.Name,
            Dosage = request.Dosage,
            Instructions = request.Instructions,
            StartDate = request.StartDate,
            EndDate = request.EndDate,
            Reminders = request.Reminders?.Select(time => new MedicationReminder
            {
                ReminderTime = time
            }).ToList() ?? new List<MedicationReminder>()
        };

        _db.Medications.Add(entity);
        await _db.SaveChangesAsync();
        return _mapper.Map<MedicationDto>(entity);
    }

    public async Task<MedicationDto?> UpdateAsync(Guid userId, Guid medicationId, UpdateMedicationRequest request)
    {
        var entity = await _db.Medications.Include(m => m.Reminders).FirstOrDefaultAsync(x => x.Id == medicationId && x.UserId == userId);
        if (entity is null) return null;

        entity.Name = request.Name;
        entity.Dosage = request.Dosage;
        entity.Instructions = request.Instructions;
        entity.StartDate = request.StartDate;
        entity.EndDate = request.EndDate;
        entity.UpdatedAt = DateTime.UtcNow;

        if (request.Reminders is not null)
        {
            _db.MedicationReminders.RemoveRange(entity.Reminders);
            entity.Reminders = request.Reminders.Select(time => new MedicationReminder { ReminderTime = time }).ToList();
        }

        await _db.SaveChangesAsync();
        return _mapper.Map<MedicationDto>(entity);
    }

    public async Task<bool> DeleteAsync(Guid userId, Guid medicationId)
    {
        var entity = await _db.Medications.FirstOrDefaultAsync(x => x.UserId == userId && x.Id == medicationId);
        if (entity is null) return false;
        _db.Medications.Remove(entity);
        await _db.SaveChangesAsync();
        return true;
    }
}
