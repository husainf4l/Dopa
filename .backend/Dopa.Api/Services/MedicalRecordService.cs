using AutoMapper;
using AutoMapper.QueryableExtensions;
using Dopa.Api.Configurations;
using Dopa.Api.Data;
using Dopa.Api.Dtos;
using Dopa.Api.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace Dopa.Api.Services;

public class MedicalRecordService : IMedicalRecordService
{
    private readonly AppDbContext _db;
    private readonly IMapper _mapper;
    private readonly IWebHostEnvironment _environment;
    private readonly StorageOptions _options;

    public MedicalRecordService(AppDbContext db, IMapper mapper, IWebHostEnvironment environment, IOptions<StorageOptions> options)
    {
        _db = db;
        _mapper = mapper;
        _environment = environment;
        _options = options.Value;
    }

    public async Task<IEnumerable<MedicalRecordDto>> GetAsync(Guid userId)
    {
        return await _db.MedicalRecords
            .Where(x => x.UserId == userId)
            .ProjectTo<MedicalRecordDto>(_mapper.ConfigurationProvider)
            .ToListAsync();
    }

    public async Task<MedicalRecordDto?> UploadAsync(Guid userId, CreateMedicalRecordRequest request, IFormFile file)
    {
        if (file is null || file.Length == 0)
        {
            return null;
        }

        var uploadsRoot = Path.Combine(_environment.ContentRootPath, _options.RootPath);
        Directory.CreateDirectory(uploadsRoot);
        var fileName = $"{Guid.NewGuid()}_{file.FileName}";
        var filePath = Path.Combine(uploadsRoot, fileName);

        await using var stream = File.Create(filePath);
        await file.CopyToAsync(stream);

        var record = new MedicalRecord
        {
            UserId = userId,
            Title = request.Title,
            Description = request.Description,
            FilePath = Path.Combine(_options.RootPath, fileName),
            ContentType = file.ContentType
        };

        _db.MedicalRecords.Add(record);
        await _db.SaveChangesAsync();
        return _mapper.Map<MedicalRecordDto>(record);
    }

    public async Task<bool> DeleteAsync(Guid userId, Guid recordId)
    {
        var entity = await _db.MedicalRecords.FirstOrDefaultAsync(x => x.Id == recordId && x.UserId == userId);
        if (entity is null) return false;
        _db.MedicalRecords.Remove(entity);
        await _db.SaveChangesAsync();
        var fullPath = Path.Combine(_environment.ContentRootPath, entity.FilePath);
        if (File.Exists(fullPath))
        {
            File.Delete(fullPath);
        }
        return true;
    }
}
