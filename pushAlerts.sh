#!/bin/bash

hasNextPage="true"
while [ $hasNextPage = "true"  ]
do
gh api graphql -F owner='{owner}' -F name='{repo}'  -f query='
    query alerts ($owner: String!, $name: String!) {
		repository(owner:$owner, name:$name) 
		{
			vulnerabilityAlerts(last:100, states: [AUTO_DISMISSED,DISMISSED,OPEN,FIXED])
			{      
				pageInfo 
				{        
					endCursor        
					hasNextPage        
					startCursor
					hasPreviousPage      
				}      
				totalCount      
				nodes 
				{        
					id  
					autoDismissedAt
					createdAt
					dismissReason
					dismissedAt
					state
					fixedAt
					vulnerableManifestPath
					dismisser {
						email
						name
						login
					}
					securityAdvisory {
						id
						cvss {
							score
						}
						ghsaId
						severity
						summary
						notificationsPermalink
						permalink
						publishedAt
						origin
						identifiers
						{
							type: value
						}
						updatedAt
						description
					}
					securityVulnerability 
					{
						firstPatchedVersion {
							identifier
						}
						package
						{
							ecosystem
							name
						}
						vulnerableVersionRange
						updatedAt
					}
				}
			}
		}
    }' > alerts.json

 hasNextPage=`jq -r '.data.repository.vulnerabilityAlerts.pageInfo.hasNextPage' alerts.json`
 echo $hasNextPage
 after=`jq -r '.data.repository.vulnerabilityAlerts.pageInfo.endCursor' alerts.json`
 echo $after 
done
