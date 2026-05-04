import { createWorkflow } from '@mastra/core';
import { MCPClient } from '@mastra/core/mcp';

const dsn = process.env.SDLC_STATE_RAG_DSN ?? '';
if (!dsn) throw new Error('SDLC_STATE_RAG_DSN required');

const stateRag = new MCPClient({
  servers: {
    'sdlc-state-rag': {
      command: 'npx',
      args: ['-y', '@ypolosov/sdlc-state-rag'],
      env: { SDLC_STATE_RAG_DSN: dsn },
    },
  },
});

const reindexWorkflow = createWorkflow({
  id: 'reindex-cron',
  schedule: { cron: '0 */4 * * *' },
  steps: [
    async () => {
      const tools = await stateRag.getTools();
      await tools['sdlc-state-rag.rag_upsert_documents']({
        documents: await collectFromFilesystem(),
      });
    },
  ],
});

async function collectFromFilesystem(): Promise<unknown[]> {
  return [];
}

export { reindexWorkflow };
