using Dopa.Api.Dtos;
using System;
using System.Threading.Tasks;

namespace Dopa.Api.Services;

public interface IUserService
{
    Task<UserProfileDto?> GetProfileAsync(Guid userId);
    Task<UserProfileDto?> UpdateProfileAsync(Guid userId, UpdateUserProfileRequest request);
}
