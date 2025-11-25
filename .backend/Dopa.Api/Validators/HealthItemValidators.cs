using Dopa.Api.Dtos;
using FluentValidation;

namespace Dopa.Api.Validators;

public class CreateMedicationRequestValidator : AbstractValidator<CreateMedicationRequest>
{
    public CreateMedicationRequestValidator()
    {
        RuleFor(x => x.Name).NotEmpty();
        RuleFor(x => x.StartDate).LessThanOrEqualTo(x => x.EndDate ?? x.StartDate.AddYears(1))
            .WithMessage("Start date must be before end date");
    }
}

public class UpdateMedicationRequestValidator : AbstractValidator<UpdateMedicationRequest>
{
    public UpdateMedicationRequestValidator()
    {
        RuleFor(x => x.Name).NotEmpty();
    }
}

public class CreateAppointmentRequestValidator : AbstractValidator<CreateAppointmentRequest>
{
    public CreateAppointmentRequestValidator()
    {
        RuleFor(x => x.DoctorName).NotEmpty();
        RuleFor(x => x.AppointmentDate).GreaterThan(DateTime.UtcNow.AddMinutes(-1));
    }
}

public class CreateVaccineDoseRequestValidator : AbstractValidator<CreateVaccineDoseRequest>
{
    public CreateVaccineDoseRequestValidator()
    {
        RuleFor(x => x.VaccineName).NotEmpty();
        RuleFor(x => x.DoseNumber).NotEmpty();
    }
}
