# pmn-projet-part2

- (local) git clone dolibarr
- (local) création vhost
- (local) création dockerfile


## Commande k8s

- kompose convert : créer de la config depuis un docker compose
    - Valeur correcte apiVersion: apps/v1
    - Ajout selector:
      matchLabels:
      io.kompose.service: web
    - 
- kubectl apply -f <file>.yaml : execute un fichier deployment k8s
- kubectl get pods : liste pods actifs
- kubectl delete pod <nom-du-pod> : Supprime un pod

