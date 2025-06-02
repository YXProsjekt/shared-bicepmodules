@description('Required. Name of setting.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

param targetResourceId string

param enabled bool = true

param capacity capacityType = {
  default: 3
  minimum: 1
  maximum: 5
}

param rules autoScaleRule[]

resource autoscale 'Microsoft.Insights/autoscalesettings@2022-10-01' = {
  name: name
  location: location
  properties: {
    enabled: enabled
    targetResourceUri: targetResourceId
    profiles: [
      {
        capacity: {
          default: string(capacity.default)
          minimum: string(capacity.minimum)
          maximum: string(capacity.maximum)
        }
        name: 'Auto created scale condition'
        rules: rules
      }
    ]
  }
}

type capacityType = {
  @minValue(1)
  @maxValue(30)
  default: int
  @minValue(1)
  minimum: int
  @minValue(1)
  maximum: int
}

type autoScaleRule = {
  scaleAction: {
    type: 'ChangeCount' | 'ExactCount' | 'PercentChangeCount' | 'ServiceAllowedNextValue'
    direction: 'Increase' | 'Decrease' | 'None'
    cooldown: string
    value: string
  }
  metricTrigger: {
    metricResourceUri: string
    timeWindow: string
    @minValue(0)
    threshold: int
    metricName: string
    statistic: 'Average' | 'Count' | 'Max' | 'Min' | 'Sum' 
    timeGrain: string
    operator: 'Equals' | 'GreaterThan' | 'GreaterThanOrEqual' | 'LessThan' | 'LessThanOrEqual' | 'NotEquals'
    timeAggregation: 'Average' | 'Count' | 'Last' | 'Maximum' | 'Minimum' | 'Total'
  }
}
