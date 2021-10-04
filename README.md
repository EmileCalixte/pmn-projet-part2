# pmn-projet-part2

## Installation sur un cluster k8s Azure

### Création du cluster

Créer un cluster kubernetes
- Basics
  - Resource group : `pmn-k8s-rg`
  - Kubernetes cluster name : `pmn-k8s`
  - Zone : France Central
  - Availability zones : Zones 1,2,3
  - Kubernetes version : 1.20.9 (default)
  - Node size : Standard B2s
  - Scale method : Manual
  - Node count : 3
- Authentication
  - Authentication method : System-assigned managed identity
  - RBAC : Enabled
  - AKS-managed Azure Active Directory : Non
  - Encryption type : Default
- Networking
  - Network configuration : Kubenet
  - Enable HTTP application routing : Oui
  - Network policy : None
- Integrations :
  - Container registry : (New)
    - Name : pmnk8scr
    - Resource group : `pmn-k8s-rg`
    - Region : France Central
    - Admin user : Enable
    - SKU : Basic
  - Container monitoring : Disabled
  - Azure Policy : Disabled

### Liaison du repository git

Sélectionner le service Kubernetes `pmn-k8s`, puis dans la section "Deployment Center" sélectionner Github autoriser Azure à accéder à son compte Github.

Une fois connecté, sélectionner le bon repository (pmn-projet-part2).

Azure détecte le Dockerfile et indique qu'il va déployer l'application sur le port 80. Valider.

Laisser les paramètres par défaut pour le Namespace (Azure le crée automatiquement) et pour le Container Registry (il utilise celui créé lors de la création du cluster).

Cliquer sur "Done" pour lancer le déploiement.

Azure va automatiquement créer un workflow Github et des manifests de déploiement Kubernetes.

### Configuration du workflow de déploiement

Dans le fichier `workflows/deployToAksCluster.yml`, remplacer le contenu de la variable `manifests` par le contenu suivant :

```yaml
        manifests: |
          manifests/azure-file-web-storage-class.yaml
          manifests/azure-disk-db-storage-class.yaml
          manifests/dolibarr-data-persistentvolumeclaim.yaml
          manifests/dolibarr-documents-persistentvolumeclaim.yaml
          manifests/mariadb-data-persistentvolumeclaim.yaml
          manifests/database-deployment.yaml
          manifests/web-deployment.yaml
          manifests/service.database.yaml
          manifests/web-load-balancer.yaml
```

Dans le fichier `manifests/web-deployment.yaml`, remplacer le contenu de la variable `spec.template.spec.containers[0].image` par

```yaml
image: "pmnk8scr.azurecr.io/pmnk8s"
```

Supprimer les fichiers
- `manifests/deployment.yml`
- `manifests/ingress.yml`
- `manifests/service.yml`

(Ces fichiers ont été générés par Azure mais on ne s'en sert pas puisqu'on a nos propres manifests)

### Manipulations avec Azure CLI

```bash
az login
az aks get-credentials --name pmn-k8s --resource-group pmn-k8s-rg
kubectl config set-context --current --namespace=<nom-namespace>
```

<br>

---
#### (optionnel) Changement de compte

Si le `az aks get-credentials` ne fonctionne pas, c'est peut-être parce que plusieurs comptes sont configurés sous les mêmes identifiants.

Utiliser les commandes `az account show`, `az account list` et `az account set --subscription "<nom de l'abonnement>"` pour se positionner sur le bon abonnement, puis réexécuter la commande

```bash
az aks get-credentials --name pmn-k8s --resource-group pmn-k8s-rg
```
---
<br>


Pour récupérer l'adresse IP pour se connecter à l'application :

```bash
kubectl get services
```

=> Récupérer l'External IP du service `web-load-balancer` et la mettre dans un navigateur pour accéder à l'application.

Pour récupérer les pods :

```bash
kubectl get pods
```

```bash
kubectl delete pod/<nom>
```

=> Après suppression du pod, constater que l'application est toujours accessible, et qu'un nouveau pod a été créé.

### Configuration de Dolibarr

- Nom de la base de données : `dolibarr`
- Pilote : `mysqli`
- Serveur : `database`
- Port: 3306
- Identifiant : `root`
- Mot de passe `admin`
- Créer le propriétaire : Non