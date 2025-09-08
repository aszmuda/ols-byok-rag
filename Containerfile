ARG BYOK_TOOL_IMAGE=registry.redhat.io/openshift-lightspeed-tech-preview/lightspeed-rag-tool-rhel9
ARG UBI_BASE_IMAGE=registry.access.redhat.com/ubi9/ubi:latest
FROM ${BYOK_TOOL_IMAGE} as tool
ARG UBI_BASE_IMAGE
ARG VECTOR_DB_INDEX=vector_db_index

USER 0
WORKDIR /workdir

COPY markdown /markdown

ENV VECTOR_DB_INDEX=$VECTOR_DB_INDEX
RUN python3.11 generate_embeddings_tool.py -i /markdown -emd embeddings_model \
    -emn sentence-transformers/all-mpnet-base-v2 -o vector_db -id $VECTOR_DB_INDEX

FROM ${UBI_BASE_IMAGE}
COPY --from=tool /workdir/vector_db /rag/vector_db