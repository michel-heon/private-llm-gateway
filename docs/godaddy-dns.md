# GoDaddy DNS

## Role

If you use GoDaddy DNS, point your public hostname (for example `llm.example.com`) to your Azure HTTPS proxy.

## Example steps

1. Create `A`/`CNAME` record for `llm.example.com` (placeholder).
2. Verify DNS propagation.
3. Validate TLS certificate for your domain on Azure proxy.

## Important

DNS only maps hostname to your Azure endpoint. Authentication and security controls still belong at your HTTPS proxy.

## TODOs

- TODO: Replace placeholder hostname with YOUR_DOMAIN.
