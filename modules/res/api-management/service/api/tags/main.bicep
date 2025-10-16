@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Conditional. The name of the parent API. Required if the template is used in a standalone deployment.')
param apiName string

@description('Required. The name of the tag.')
param name string

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName

  resource api 'apis@2022-08-01' existing = {
    name: apiName
  }
}

resource tag 'Microsoft.ApiManagement/service/apis/tags@2024-05-01' = {
  parent: service::api
  name: name
}
  

