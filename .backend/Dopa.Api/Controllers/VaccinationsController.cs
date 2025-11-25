using System.Security.Claims;
using Dopa.Api.Dtos;
using Dopa.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Dopa.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/vaccinations")]
public class VaccinationsController : ControllerBase
{
    private readonly IVaccinationService _vaccinationService;

    public VaccinationsController(IVaccinationService vaccinationService)
    {
        _vaccinationService = vaccinationService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<VaccineDoseDto>>> Get()
    {
        var items = await _vaccinationService.GetAsync(GetUserId());
        return Ok(items);
    }

    [HttpPost]
    public async Task<ActionResult<VaccineDoseDto?>> Create(CreateVaccineDoseRequest request)
    {
        var created = await _vaccinationService.CreateAsync(GetUserId(), request);
        return created is null ? BadRequest() : CreatedAtAction(nameof(Get), new { id = created.Id }, created);
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult<VaccineDoseDto?>> Update(Guid id, UpdateVaccineDoseRequest request)
    {
        var updated = await _vaccinationService.UpdateAsync(GetUserId(), id, request);
        return updated is null ? NotFound() : Ok(updated);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _vaccinationService.DeleteAsync(GetUserId(), id);
        return deleted ? NoContent() : NotFound();
    }

    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
}
