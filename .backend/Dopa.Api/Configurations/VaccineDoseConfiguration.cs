using Dopa.Api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Dopa.Api.Configurations;

public class VaccineDoseConfiguration : IEntityTypeConfiguration<VaccineDose>
{
    public void Configure(EntityTypeBuilder<VaccineDose> builder)
    {
        builder.Property(v => v.VaccineName).IsRequired().HasMaxLength(200);
        builder.Property(v => v.DoseNumber).IsRequired().HasMaxLength(50);
    }
}
