# Basic Key-Based Verification Example

See the Kubernetes manifest in `../../manifests/` for a full deployment example.

## Steps

1. Sign your image:
   ```sh
   cosign sign --key cosign.key registry.example.com/my-app:1.4.2
   ```

2. Create a secret from your public key:
   ```sh
   kubectl create secret generic cosign-pub --from-file=cosign.pub=./cosign.pub
   ```

3. Apply the example manifest:
   ```sh
   kubectl apply -f ../../manifests/example-deployment.yaml
   ```
