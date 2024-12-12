# **Security Enhancements**

This document outlines recommended security practices for the project.

---

## **Platform Security**

1. **Key Management**:
   - Use Azure Key Vault for secure storage of secrets and connection strings. (if not using managed Identity)

2. **Access Controls**:
   - Implement RBAC for users with roles like `Uploader` and `Viewer`.

---

## **Application Security**

1. **Input Validation**:
   - Validate file size and metadata to prevent malicious uploads. (reduces attack vector and minimises risk against malicious injections)

2. **Authentication**:
   - Use Azure AD B2C for secure user logins. (if users want to view the files listed within the blob)

---

## **Network Security**

1. **Custom Domains**:
   - Use HTTPS with free Azure SSL certificates.

2. **Web Application Firewall**:
   - Enable Azure WAF for traffic filtering.

---

## **Monitoring**

1. **Audit Logs**:
   - Enable and monitor Azure Activity Logs for suspicious activity.

2. **Alerts**:
   - Set up alerts for unauthorized access or unusual traffic spikes.
