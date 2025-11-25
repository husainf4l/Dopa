using Dopa.Api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Dopa.Api.Configurations;

public class ResourceArticleConfiguration : IEntityTypeConfiguration<ResourceArticle>
{
    public void Configure(EntityTypeBuilder<ResourceArticle> builder)
    {
        builder.Property(r => r.Title).IsRequired().HasMaxLength(200);
        builder.Property(r => r.Category).HasMaxLength(100);
        builder.Property(r => r.SourceUrl).HasMaxLength(500);
    }
}
