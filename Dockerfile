#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ExceptionLogs/ExceptionLogs.csproj", "ExceptionLogs/"]
RUN dotnet restore "ExceptionLogs/ExceptionLogs.csproj"
COPY . .
WORKDIR "/src/ExceptionLogs"
RUN dotnet build "ExceptionLogs.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ExceptionLogs.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ExceptionLogs.dll"]