using System;

namespace Dopa.Api.Dtos;

public record RegisterRequest(string Email, string Password, string FullName, DateTime? DateOfBirth);
public record LoginRequest(string Email, string Password);
public record AuthResponse(Guid UserId, string Email, string FullName, string Token, DateTime ExpiresAt);
public record RefreshTokenRequest(string Token);
