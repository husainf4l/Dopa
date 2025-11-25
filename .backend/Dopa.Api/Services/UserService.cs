using AutoMapper;
using Dopa.Api.Data;
using Dopa.Api.Dtos;
using Microsoft.EntityFrameworkCore;

namespace Dopa.Api.Services;

public class UserService : IUserService
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;

    public UserService(AppDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }

    public async Task<UserProfileDto?> GetProfileAsync(Guid userId)
    {
        var entity = await _db.Users.FirstOrDefaultAsync(x => x.Id == userId);
        return entity is null ? null : _mapper.Map<UserProfileDto>(entity);
    }

    public async Task<UserProfileDto?> UpdateProfileAsync(Guid userId, UpdateUserProfileRequest request)
    {
        var entity = await _db.Users.FirstOrDefaultAsync(x => x.Id == userId);
        if (entity is null) return null;
        entity.FullName = request.FullName;
        entity.DateOfBirth = request.DateOfBirth;
        entity.DeviceToken = request.DeviceToken;
        entity.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return _mapper.Map<UserProfileDto>(entity);
    }
}
