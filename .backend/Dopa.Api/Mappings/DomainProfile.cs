using AutoMapper;
using Dopa.Api.Dtos;
using Dopa.Api.Models;

namespace Dopa.Api.Mappings;

public class DomainProfile : Profile
{
    public DomainProfile()
    {
        CreateMap<User, UserProfileDto>();
        CreateMap<Medication, MedicationDto>();
        CreateMap<MedicationReminder, MedicationReminderDto>();
        CreateMap<Appointment, AppointmentDto>();
        CreateMap<VaccineDose, VaccineDoseDto>();
        CreateMap<MedicalRecord, MedicalRecordDto>();
        CreateMap<ResourceArticle, ResourceArticleDto>();
    }
}
