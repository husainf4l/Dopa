using Dopa.Api.Dtos;

namespace Dopa.Api.Services.Security;

public interface IJwtTokenService
{
    AuthResponse CreateToken(Guid userId, string email, string fullName);
}
