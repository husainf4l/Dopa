using AutoMapper;
using AutoMapper.QueryableExtensions;
using Dopa.Api.Data;
using Dopa.Api.Dtos;
using Dopa.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Dopa.Api.Services;

public class ResourceService : IResourceService
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;

    public ResourceService(AppDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }

    public async Task<IEnumerable<ResourceArticleDto>> GetAsync()
    {
        return await _db.ResourceArticles
            .OrderByDescending(x => x.PublishedAt)
            .ProjectTo<ResourceArticleDto>(_mapper.ConfigurationProvider)
            .ToListAsync();
    }

    public async Task<ResourceArticleDto> CreateAsync(CreateResourceArticleRequest request)
    {
        var entity = new ResourceArticle
        {
            Title = request.Title,
            Summary = request.Summary,
            Content = request.Summary,
            Category = request.Category,
            SourceUrl = request.SourceUrl,
            PublishedAt = DateTime.UtcNow
        };

        _db.ResourceArticles.Add(entity);
        await _db.SaveChangesAsync();
        return _mapper.Map<ResourceArticleDto>(entity);
    }
}
