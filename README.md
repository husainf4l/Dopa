# DOPA

DOPA (Digital Organizer for Personal Health Administration) is a centralized health management starter kit with a .NET 8 API, PostgreSQL persistence, hosted reminder engine, and a Flutter 3 mobile client. It helps families and caregivers track medications, doctor appointments, vaccinations, medical records, and curated health resources from a single secure workspace.

## Tech Stack

- **Backend**: ASP.NET Core 8 Web API, EF Core, PostgreSQL, AutoMapper, FluentValidation, JWT Auth, Serilog, Firebase Admin
- **Background Services**: Hosted reminder worker with push notification sender
- **Frontend**: Flutter 3.22, Riverpod, GoRouter, Dio, Firebase Messaging, flutter_local_notifications, flutter_secure_storage
- **Infrastructure**: Dockerfile for API, Docker Compose with PostgreSQL + pgAdmin, sample env files

## Folder Structure

```
.
├── .backend/
│   └── Dopa.Api/            # ASP.NET Core solution
│       ├── Controllers/
│       ├── Models/
│       ├── Dtos/
│       ├── Services/
│       ├── Data/
│       ├── Background/
│       ├── Notifications/
│       ├── Extensions/
│       ├── appsettings*.json
│       └── Dockerfile
├── .app/                    # Flutter client
│   ├── lib/
│   │   ├── features/
│   │   ├── providers/
│   │   ├── services/
│   │   ├── models/
│   │   ├── routes/
│   │   └── theme/
│   ├── analysis_options.yaml
│   └── pubspec.yaml
├── env/backend.env          # Sample backend env variables
├── docker-compose.yml
└── README.md
```

## Backend Setup (.backend/Dopa.Api)

1. **Install prerequisites**: .NET 8 SDK, Docker, PostgreSQL client tools.
2. **Configure environment**:
   - Duplicate `env/backend.env` or use user-secrets.
   - Set connection strings, JWT secrets, Firebase credentials.
3. **Apply migrations**:
   ```bash
   cd .backend/Dopa.Api
   dotnet ef database update
   ```
4. **Run API locally**:
   ```bash
   dotnet run
   ```
   API will listen on `http://localhost:5081` by default.
5. **Dockerized run**:
   ```bash
   docker compose up --build
   ```
   - `api` service exposes port `8080`
   - `postgres` on `5432`
   - `pgadmin` UI on `8081`

### Firebase

- Provide a service account key JSON and set `GOOGLE_APPLICATION_CREDENTIALS` before running the API or mount inside the container.
- Device tokens captured via the Flutter app will be stored per user for reminder pushes.

### PostgreSQL Configuration

Default compose credentials:
- Host: `localhost`
- Port: `5432`
- Database: `dopa_db`
- User: `dopa_user`
- Password: `supersecret`

Override via `ConnectionStrings__Postgres` environment variable.

## Frontend Setup (.app)

1. **Install prerequisites**: Flutter 3.22 SDK, Dart 3.4, Android/iOS tooling, Firebase CLI.
2. **Dependencies**:
   ```bash
   cd .app
   flutter pub get
   ```
3. **Configure API endpoint**: set compile-time env `--dart-define=API_BASE_URL=http://localhost:8080/api` when running against Docker.
4. **Firebase**:
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
   - Enable Cloud Messaging, download configs, and run `flutterfire configure` if desired.
5. **Run app**:
   ```bash
   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api
   ```

## Reminder Engine

- Hosted service polls medications, appointments, and vaccines on intervals defined in `Reminder` config.
- Sends push notifications through `FirebaseNotificationSender` using stored device tokens.

## Environment Variables

| Key | Description |
| --- | --- |
| `ConnectionStrings__Postgres` | PostgreSQL connection string |
| `Jwt__Secret` | Secret used for HMAC signing |
| `Jwt__Issuer` / `Jwt__Audience` | JWT issuer/audience values |
| `Storage__RootPath` | Relative folder for medical file uploads |
| `Reminder__*` | Lead times & polling intervals |
| `GOOGLE_APPLICATION_CREDENTIALS` | Path to Firebase service account JSON |

Example `.env` snippet:
```
ConnectionStrings__Postgres=Host=localhost;Port=5432;Database=dopa_db;Username=dopa_user;Password=supersecret
Jwt__Secret=CHANGE_ME
Jwt__Issuer=Dopa
Jwt__Audience=Dopa.Mobile
Storage__RootPath=Files
Reminder__MedicationLeadMinutes=30
Reminder__AppointmentLeadMinutes=60
Reminder__VaccineLeadHours=24
Reminder__PollingIntervalSeconds=60
```

## Running Tests

- Backend: `dotnet test` (tests can be added under `.backend/Dopa.Api.Tests`).
- Frontend: `flutter test`.

## GitHub Deployment

After configuring your secrets and remote, push to `main` using the commands listed in the setup instructions.
