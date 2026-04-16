const { app } = require("@azure/functions");
const { DefaultAzureCredential } = require("@azure/identity");
const { ServiceBusClient } = require("@azure/service-bus");

function requireEnv(name) {
  const v = process.env[name];
  if (!v) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return v;
}

app.http("ping", {
  methods: ["GET"],
  authLevel: "anonymous",
  route: "ping",
  handler: async (request, context) => {
    const fqdn = requireEnv("ServiceBus__FullyQualifiedNamespace");
    const queueName = requireEnv("ServiceBus__QueueName");

    const credential = new DefaultAzureCredential();
    const sb = new ServiceBusClient(fqdn, credential);
    const sender = sb.createSender(queueName);

    const now = new Date().toISOString();
    const message = {
      body: { event: "ping", at: now },
      contentType: "application/json"
    };

    try {
      await sender.sendMessages(message);
      return {
        status: 200,
        jsonBody: {
          ok: true,
          at: now,
          queued: true
        }
      };
    } catch (err) {
      context.error("Failed to enqueue message", err);
      return {
        status: 500,
        jsonBody: {
          ok: false,
          at: now,
          error: "Failed to enqueue message"
        }
      };
    } finally {
      await sender.close();
      await sb.close();
    }
  }
});

