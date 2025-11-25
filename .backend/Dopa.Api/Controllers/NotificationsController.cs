using Dopa.Api.Notifications;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Dopa.Api.Controllers;

[ApiController]
[Route("api/notifications")]
[Authorize(Roles = "admin")]
public class NotificationsController : ControllerBase
{
    private readonly INotificationSender _notificationSender;

    public NotificationsController(INotificationSender notificationSender)
    {
        _notificationSender = notificationSender;
    }

    public record SendNotificationRequest(string Title, string Body, string DeviceToken);

    [HttpPost]
    public async Task<IActionResult> Send(SendNotificationRequest request)
    {
        await _notificationSender.SendAsync(request.Title, request.Body, request.DeviceToken);
        return Accepted();
    }
}
