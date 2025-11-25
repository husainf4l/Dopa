using System;

namespace Dopa.Api.Dtos;

public record UserProfileDto(Guid Id, string Email, string FullName, DateTime? DateOfBirth, string Role, string? DeviceToken);
public record UpdateUserProfileRequest(string FullName, DateTime? DateOfBirth, string? DeviceToken);
