using System.Threading.Tasks;
using Dopa.Api.Dtos;

namespace Dopa.Api.Services;

public interface IAuthService
{
    Task<AuthResponse> RegisterAsync(RegisterRequest request);
    Task<AuthResponse> LoginAsync(LoginRequest request);
}
