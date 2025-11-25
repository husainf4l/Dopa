using Dopa.Api.Dtos;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Dopa.Api.Services;

public interface IResourceService
{
    Task<IEnumerable<ResourceArticleDto>> GetAsync();
    Task<ResourceArticleDto> CreateAsync(CreateResourceArticleRequest request);
}
