using System.Threading.Tasks;

namespace Dopa.Api.Notifications;

public interface INotificationSender
{
    Task SendAsync(string title, string body, string? deviceToken);
}
