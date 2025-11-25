using Dopa.Api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Dopa.Api.Configurations;

public class MedicationConfiguration : IEntityTypeConfiguration<Medication>
{
    public void Configure(EntityTypeBuilder<Medication> builder)
    {
        builder.Property(m => m.Name).IsRequired().HasMaxLength(200);
        builder.Property(m => m.Dosage).HasMaxLength(100);

        builder.HasMany(m => m.Reminders)
            .WithOne(r => r.Medication)
            .HasForeignKey(r => r.MedicationId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
