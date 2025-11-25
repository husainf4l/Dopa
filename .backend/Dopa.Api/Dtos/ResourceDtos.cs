using System;

namespace Dopa.Api.Dtos;

public record ResourceArticleDto(Guid Id, string Title, string Summary, string Category, string SourceUrl, DateTime PublishedAt);
public record CreateResourceArticleRequest(string Title, string Summary, string Category, string SourceUrl);
