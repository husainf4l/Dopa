using Dopa.Api.Data;
using Dopa.Api.Dtos;
using Dopa.Api.Models;
using Dopa.Api.Services.Security;
using Microsoft.EntityFrameworkCore;

namespace Dopa.Api.Services;

public class AuthService : IAuthService
{
    private readonly AppDbContext _db;
    private readonly IPasswordService _passwordService;
    private readonly IJwtTokenService _jwtTokenService;

    public AuthService(AppDbContext db, IPasswordService passwordService, IJwtTokenService jwtTokenService)
    {
        _db = db;
        _passwordService = passwordService;
        _jwtTokenService = jwtTokenService;
    }

    public async Task<AuthResponse> RegisterAsync(RegisterRequest request)
    {
        if (await _db.Users.AnyAsync(u => u.Email == request.Email))
        {
            throw new InvalidOperationException("Email already exists");
        }

        var user = new User
        {
            Email = request.Email.ToLowerInvariant(),
            PasswordHash = _passwordService.HashPassword(request.Password),
            FullName = request.FullName,
            DateOfBirth = request.DateOfBirth
        };

        _db.Users.Add(user);
        await _db.SaveChangesAsync();

        return _jwtTokenService.CreateToken(user.Id, user.Email, user.FullName);
    }

    public async Task<AuthResponse> LoginAsync(LoginRequest request)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == request.Email.ToLowerInvariant());
        if (user is null || !_passwordService.VerifyPassword(request.Password, user.PasswordHash))
        {
            throw new UnauthorizedAccessException("Invalid credentials");
        }

        return _jwtTokenService.CreateToken(user.Id, user.Email, user.FullName);
    }
}
