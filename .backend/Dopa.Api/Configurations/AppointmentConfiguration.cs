using Dopa.Api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Dopa.Api.Configurations;

public class AppointmentConfiguration : IEntityTypeConfiguration<Appointment>
{
    public void Configure(EntityTypeBuilder<Appointment> builder)
    {
        builder.Property(a => a.DoctorName).IsRequired().HasMaxLength(200);
        builder.Property(a => a.Location).HasMaxLength(200);
    }
}
