using FirebaseAdmin.Messaging;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;

namespace Dopa.Api.Notifications;

public class FirebaseNotificationSender : INotificationSender
{
    private readonly ILogger<FirebaseNotificationSender> _logger;

    public FirebaseNotificationSender(ILogger<FirebaseNotificationSender> logger)
    {
        _logger = logger;
    }

    public async Task SendAsync(string title, string body, string? deviceToken)
    {
        if (string.IsNullOrWhiteSpace(deviceToken))
        {
            _logger.LogWarning("No device token provided for notification {Title}", title);
            return;
        }

        var message = new Message
        {
            Token = deviceToken,
            Notification = new Notification
            {
                Title = title,
                Body = body
            }
        };

        try
        {
            await FirebaseMessaging.DefaultInstance.SendAsync(message);
        }
        catch (FirebaseMessagingException ex)
        {
            _logger.LogError(ex, "Failed to send notification");
        }
    }
}
