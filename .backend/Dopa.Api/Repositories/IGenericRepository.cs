using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Dopa.Api.Models;

namespace Dopa.Api.Repositories;

public interface IGenericRepository<T> where T : BaseEntity
{
    Task<T?> GetAsync(Guid id);
    Task<IReadOnlyList<T>> GetManyAsync(Expression<Func<T, bool>> filter);
    Task<T> AddAsync(T entity);
    Task UpdateAsync(T entity);
    Task DeleteAsync(T entity);
}
