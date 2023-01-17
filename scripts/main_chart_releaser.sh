#!/bin/bash
set -e
set -o pipefail

function update_tk_main_chart_version {
    # calculate patch version by incrementing by one:
    tk_version_full=$(grep -iE "^version:" ../charts/testkube/Chart.yaml | awk '{print $NF}')

    # Bumping TestKube version by one:
    tk_version_major=$(echo $tk_version_full | awk -F\. '{print $1}')
    tk_version_minor=$(echo $tk_version_full | awk -F\. '{print $2}')
    tk_version_patch=$(echo $tk_version_full | awk -F\. '{print $3}')

    # Incrementing testKube helm charts patch version by one:
    tk_version_patch=$(expr $tk_version_patch + 1)

    # New TestKube full version:
    tk_version_full_bumped=$tk_version_major.$tk_version_minor.$tk_version_patch
}


# Checking new TestKube full version:
echo "New main TestKube's chart version is: $tk_version_full_bumped"

# Editing TestKube's main chart version:
sed -i "s/^version:.*/version: $tk_version_full_bumped/" ../charts/testkube/Chart.yaml
echo -e "\nChecking if testkube's main Chart.yaml version has been updated:\n"
grep -iE "^version" ../charts/testkube/Chart.yaml

# Commiting and pushing changes:
git add -A
git commit -m "Tag: $tk_version_full_bumped; CI/CD. Bumped main helm chart version."

# git push origin main
git push --set-upstream https://kubeshop-bot:$GH_PUSH_TOKEN@github.com/kubeshop/helm-charts update-tk-chart-script