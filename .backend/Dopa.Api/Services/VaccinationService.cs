using AutoMapper;
using AutoMapper.QueryableExtensions;
using Dopa.Api.Data;
using Dopa.Api.Dtos;
using Dopa.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Dopa.Api.Services;

public class VaccinationService : IVaccinationService
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;

    public VaccinationService(AppDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }

    public async Task<IEnumerable<VaccineDoseDto>> GetAsync(Guid userId)
    {
        return await _db.VaccineDoses
            .Where(x => x.UserId == userId)
            .OrderBy(x => x.ScheduledDate)
            .ProjectTo<VaccineDoseDto>(_mapper.ConfigurationProvider)
            .ToListAsync();
    }

    public async Task<VaccineDoseDto?> CreateAsync(Guid userId, CreateVaccineDoseRequest request)
    {
        var entity = new VaccineDose
        {
            UserId = userId,
            VaccineName = request.VaccineName,
            DoseNumber = request.DoseNumber,
            ScheduledDate = request.ScheduledDate,
            CompletedDate = request.CompletedDate
        };

        _db.VaccineDoses.Add(entity);
        await _db.SaveChangesAsync();
        return _mapper.Map<VaccineDoseDto>(entity);
    }

    public async Task<VaccineDoseDto?> UpdateAsync(Guid userId, Guid vaccineDoseId, UpdateVaccineDoseRequest request)
    {
        var entity = await _db.VaccineDoses.FirstOrDefaultAsync(x => x.Id == vaccineDoseId && x.UserId == userId);
        if (entity is null) return null;
        entity.VaccineName = request.VaccineName;
        entity.DoseNumber = request.DoseNumber;
        entity.ScheduledDate = request.ScheduledDate;
        entity.CompletedDate = request.CompletedDate;
        entity.UpdatedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();
        return _mapper.Map<VaccineDoseDto>(entity);
    }

    public async Task<bool> DeleteAsync(Guid userId, Guid vaccineDoseId)
    {
        var entity = await _db.VaccineDoses.FirstOrDefaultAsync(x => x.Id == vaccineDoseId && x.UserId == userId);
        if (entity is null) return false;
        _db.VaccineDoses.Remove(entity);
        await _db.SaveChangesAsync();
        return true;
    }
}
