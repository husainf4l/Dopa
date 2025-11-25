using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Dopa.Api.Data;
using Dopa.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Dopa.Api.Repositories;

public class GenericRepository<T> : IGenericRepository<T> where T : BaseEntity
{
    private readonly AppDbContext _context;
    private readonly DbSet<T> _set;

    public GenericRepository(AppDbContext context)
    {
        _context = context;
        _set = context.Set<T>();
    }

    public async Task<T?> GetAsync(Guid id) => await _set.FirstOrDefaultAsync(x => x.Id == id);

    public async Task<IReadOnlyList<T>> GetManyAsync(Expression<Func<T, bool>> filter)
        => await _set.Where(filter).AsNoTracking().ToListAsync();

    public async Task<T> AddAsync(T entity)
    {
        _set.Add(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    public async Task UpdateAsync(T entity)
    {
        _set.Update(entity);
        entity.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(T entity)
    {
        _set.Remove(entity);
        await _context.SaveChangesAsync();
    }
}
