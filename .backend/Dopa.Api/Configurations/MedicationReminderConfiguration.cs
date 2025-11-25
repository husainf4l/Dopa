using Dopa.Api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Dopa.Api.Configurations;

public class MedicationReminderConfiguration : IEntityTypeConfiguration<MedicationReminder>
{
    public void Configure(EntityTypeBuilder<MedicationReminder> builder)
    {
        builder.Property(r => r.ReminderTime).IsRequired();
    }
}
