# Set the base image as the .NET 6.0 SDK (this includes the runtime)
FROM mcr.microsoft.com/dotnet/sdk:6.0 as build-env

# Copy everything and publish the release (publish implicitly restores and builds)
WORKDIR /app
COPY . ./
RUN dotnet publish ./DotNet.GitHubAction/DotNet.GitHubAction.csproj -c Release -o out --no-self-contained

# Label the container
LABEL maintainer="Max H <maxh@tavex.studio>"
LABEL repository="https://github.com/Caltexgames/speedlevelbuilder"
LABEL homepage="https://github.com/Caltexgames/speedlevelbuilder"

# Label as GitHub action
LABEL com.github.actions.name="CI"
# Limit to 160 characters
LABEL com.github.actions.description="Quick CI"
# See branding:
# https://docs.github.com/actions/creating-actions/metadata-syntax-for-github-actions#branding
LABEL com.github.actions.icon="activity"
LABEL com.github.actions.color="orange"

# Relayer the .NET SDK, anew with the build output
FROM mcr.microsoft.com/dotnet/sdk:6.0
COPY --from=build-env /app/out .
ENTRYPOINT [ "dotnet", "/DotNet.GitHubAction.dll" ]
