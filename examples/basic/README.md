# Basic Key-Based Verification Example

See the Kubernetes manifest in `../../manifests/` for a full deployment example.

## Steps

1. Sign your image:

   ```sh
   cosign sign --key cosign.key registry.example.com/my-app@sha256:REPLACE_WITH_64_HEX_DIGEST
   ```

1. Create a secret from your public key:

   ```sh
   kubectl create secret generic cosign-pub --from-file=cosign.pub=./cosign.pub
   ```

1. Replace both placeholder digests in the example manifest with the same real
   signed digest. `VERIFY_IMAGES` rejects mutable tags; the workload must use
   the identical immutable reference. Then apply the manifest:

   ```sh
   kubectl apply -f ../../manifests/example-deployment.yaml
   ```
