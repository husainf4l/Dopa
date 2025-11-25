using Dopa.Api.Dtos;
using Dopa.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Dopa.Api.Controllers;

[ApiController]
[Route("api/resources")]
public class ResourcesController : ControllerBase
{
    private readonly IResourceService _resourceService;

    public ResourcesController(IResourceService resourceService)
    {
        _resourceService = resourceService;
    }

    [HttpGet]
    [AllowAnonymous]
    public async Task<ActionResult<IEnumerable<ResourceArticleDto>>> Get()
    {
        var articles = await _resourceService.GetAsync();
        return Ok(articles);
    }

    [HttpPost]
    [Authorize(Roles = "admin")]
    public async Task<ActionResult<ResourceArticleDto>> Create(CreateResourceArticleRequest request)
    {
        var article = await _resourceService.CreateAsync(request);
        return CreatedAtAction(nameof(Get), new { id = article.Id }, article);
    }
}
