## Cybersecurity Simple Checklist approach
### Start by getting the lay of the land.
-	Run an nmap scan to identify all devices.
-	Run PingCastle, PurpleKnight, and SharpHound/Bloodhound to identify problems that need to be addressed with active directory. Look at the attack paths and take action to limit those.
-	Run a vulnerability scanner against all systems (nessus pro is great if you're willing to pay for it, if not, you can spin up OpenVAS and use that instead). Look at the problems it flags as things to fix.
    
### Some basic protections/low hanging fruit
-	Get a next-gen firewall. Turn on all the features: DNS filtering, URL filtering, SSL decryption, download scanning, etc.
-	Implement SFP, DKIM, and DMARC on your mail domains. Turn on your spam/phishing filters and tune them.
-	Set up 3rd party DNS filtering as an additional layer. You can use free options that can filter out malicious domains such as Quad9 and Cloudflare, or go with paid options like OpenDNS, Akamai, etc.
-	Get a next gen anti-virus (EDR - Endpoint Detection & Response). Take a look at SentinelOne and Crowdstrike. Also consider getting a managed service to monitor this for you, since you want to be able to sleep and go on vacation
-	Implement LAPS to rotate admin passwords on your systems on a regular basis.
-	Run a compliance scan against your systems. CIS publishes hardening benchmarks for this for everything from firewalls to servers to desktops. DoD also publishes their own STIGs and Microsoft provides hardening guidance as well for all of their stuff. The nessus scanner is great for this as it can run those benchmarks against your systems and report back settings you should look at changing. You can build a set of GPOs and attach them to your domain with appropriate filters so all the devices get them (for example, a desktop hardening GPO filtered to apply only to desktop operating systems).
-	Network Segmentation. This one can be hard to do well if you don't have good network visibility, but find out what devices need to talk to what and then ensure they can't talk to anything they aren't supposed to. This can be ACLs set on your networking gear for example; maybe a firewall at your datacenter to wall off your servers from internal threats. There are a bunch of ways to do this.
-	Implement MFA. This is going to be a requirement for cyber insurance purposes anyway. I recommend going passwordless for this, as it meets the requirements without the hassle of typing long passwords. MFA is having two of these: 1) something you know (password), something you are (biometric), or something you have (like a phone). Sending a request to your phone and validating the request with biometrics (like faceID/touchID on an iphone) meets those requirements. Take a look at Secret Double Octopus, HYPR, Duo, Windows Hello and other MFA providers to see if they meet your needs.
-	Do phishing simulations and generate regular reports to management about failures. Then provide training to all staff on a regular basis. KnowBe4 is great, but there are many other good providers out there. Tailor the phishing simulations to the department. 
-	Get Cyber Liability Insurance.
-	Ensure the backups are working and that you have offsite, **immutable** backups. Ideally in a cloud location in a geographically different region that where the datacenter is.
-	Have annual pentests by an external company.
-	VMS: Running looking for vulnerabilities. 



### Next steps
-	Centralized patch management for OS and third party software.
-	Make sure no one has local admin access (no regular accounts - for those that need it, have a secondary account with admin credentials)
-	Setup log aggregation/monitoring system (SIEM)
-	Get rid of legacy protocols (i.e. LDAP, old SSL/TLS, LLMNR, NTLMv1, NBNR, SMB1, SMB Signing)
-	Create automatic alerts for certain windows events. 
-	Least privilege across all accounts, role based access, audit access controls. 
-	Passwordless with Yubikeys.
-	Use Trufflehog to identify exposed sensitive information. 
-	Use Recon-NG to identify information about a domain, organization, contacts, etc (OSINT Automation)
-	SIEM – create custom rules to alert based on severity; i.e. alert with SMS any vulnerability identified with a CVE of 8 or higher. 
