using System.Security.Claims;
using Dopa.Api.Dtos;
using Dopa.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Dopa.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/users/me")]
public class UsersController : ControllerBase
{
    private readonly IUserService _userService;

    public UsersController(IUserService userService)
    {
        _userService = userService;
    }

    [HttpGet]
    public async Task<ActionResult<UserProfileDto>> GetProfile()
    {
        var profile = await _userService.GetProfileAsync(GetUserId());
        return profile is null ? NotFound() : Ok(profile);
    }

    [HttpPut]
    public async Task<ActionResult<UserProfileDto>> Update(UpdateUserProfileRequest request)
    {
        var profile = await _userService.UpdateProfileAsync(GetUserId(), request);
        return profile is null ? NotFound() : Ok(profile);
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
}
