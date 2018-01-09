FROM aws/codebuild/dot-net:core-2 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM aws/codebuild/dot-net:core-2
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "core-web-api-001.dll"]