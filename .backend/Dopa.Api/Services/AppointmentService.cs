using AutoMapper;
using AutoMapper.QueryableExtensions;
using Dopa.Api.Data;
using Dopa.Api.Dtos;
using Dopa.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Dopa.Api.Services;

public class AppointmentService : IAppointmentService
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;

    public AppointmentService(AppDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }

    public async Task<IEnumerable<AppointmentDto>> GetAsync(Guid userId)
    {
        return await _db.Appointments
            .Where(x => x.UserId == userId)
            .OrderBy(x => x.AppointmentDate)
            .ProjectTo<AppointmentDto>(_mapper.ConfigurationProvider)
            .ToListAsync();
    }

    public async Task<AppointmentDto?> CreateAsync(Guid userId, CreateAppointmentRequest request)
    {
        var entity = new Appointment
        {
            UserId = userId,
            DoctorName = request.DoctorName,
            Location = request.Location,
            AppointmentDate = request.AppointmentDate,
            Notes = request.Notes
        };

        _db.Appointments.Add(entity);
        await _db.SaveChangesAsync();
        return _mapper.Map<AppointmentDto>(entity);
    }

    public async Task<AppointmentDto?> UpdateAsync(Guid userId, Guid appointmentId, UpdateAppointmentRequest request)
    {
        var entity = await _db.Appointments.FirstOrDefaultAsync(x => x.Id == appointmentId && x.UserId == userId);
        if (entity is null) return null;
        entity.DoctorName = request.DoctorName;
        entity.Location = request.Location;
        entity.AppointmentDate = request.AppointmentDate;
        entity.Notes = request.Notes;
        entity.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return _mapper.Map<AppointmentDto>(entity);
    }

    public async Task<bool> DeleteAsync(Guid userId, Guid appointmentId)
    {
        var entity = await _db.Appointments.FirstOrDefaultAsync(x => x.Id == appointmentId && x.UserId == userId);
        if (entity is null) return false;
        _db.Appointments.Remove(entity);
        await _db.SaveChangesAsync();
        return true;
    }
}
