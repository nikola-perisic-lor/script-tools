#!/bin/bash

##############################################################################
# Script to generate boilerplate code for a new feature in the frontend project

# Usage and example: ./generate-feature.sh MobilityRate

# Date: 12.02.2026.
##############################################################################

if [ -z "$1" ]; then
    echo "Error: You need to pass argument for entity name"
    exit 1
fi

GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$GIT_ROOT" ]; then
    echo "Error: Not a git repository."
    exit 1
fi

FRONTEND_SRC="$GIT_ROOT/frontend/lor-dta-mobility-web/src"

if [ ! -d "$FRONTEND_SRC" ]; then
    echo "Error: Could not find frontend src directory at: $FRONTEND_SRC"
    exit 1
fi

INPUT=$1

ENTITY_KEBAB=$(echo "$INPUT" | sed -E 's/([a-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')
ENTITY_PASCAL=$(echo "$ENTITY_KEBAB" | perl -pe 's/(^|-)(\w)/\U$2/g')
ENTITY_UPPER=$(echo "$ENTITY_KEBAB" | tr '-' '_' | tr '[:lower:]' '[:upper:]')

BASE_DIR="$FRONTEND_SRC/features/$ENTITY_KEBAB"

echo "Creating structure for: $ENTITY_KEBAB ($ENTITY_PASCAL)..."
echo "Target directory: $BASE_DIR"

mkdir -p "$BASE_DIR"/{columns,components,constants,hooks,pages,types}

# --- 1. TYPES ---
touch "$BASE_DIR/types/$ENTITY_KEBAB.types.ts"
echo "export * from \"./$ENTITY_KEBAB.types\";" > "$BASE_DIR/types/index.ts"

# --- 2. API ---
touch "$BASE_DIR/$ENTITY_KEBAB.api.ts"

# --- 3. CONSTANTS ---
cat <<EOF > "$BASE_DIR/constants/$ENTITY_KEBAB.constants.ts"
export const DEFAULT_${ENTITY_UPPER}_SORTING = [{ id: "name", desc: false }];
EOF
echo "export * from \"./$ENTITY_KEBAB.constants\";" > "$BASE_DIR/constants/index.ts"

# --- 4. COLUMNS ---
cat <<EOF > "$BASE_DIR/columns/${ENTITY_PASCAL}Columns.tsx"
import { ColumnDef } from "@tanstack/react-table";
import { useMemo } from "react";

export const use${ENTITY_PASCAL}Columns = ({ onEdit, onDelete }: any): ColumnDef<any>[] => {
  return useMemo(() => [
  ], [onEdit, onDelete]);
};
EOF
echo "export * from \"./${ENTITY_PASCAL}Columns\";" > "$BASE_DIR/columns/index.ts"

# --- 5. HOOKS ---
touch "$BASE_DIR/hooks/use${ENTITY_PASCAL}s.ts"
touch "$BASE_DIR/hooks/useCreate${ENTITY_PASCAL}.ts"
touch "$BASE_DIR/hooks/useUpdate${ENTITY_PASCAL}.ts"
touch "$BASE_DIR/hooks/useDelete${ENTITY_PASCAL}.ts"

cat <<EOF > "$BASE_DIR/hooks/index.ts"
export * from "./use${ENTITY_PASCAL}s";
export * from "./useCreate${ENTITY_PASCAL}";
export * from "./useUpdate${ENTITY_PASCAL}";
export * from "./useDelete${ENTITY_PASCAL}";
EOF

# --- 6. COMPONENTS ---
cat <<EOF > "$BASE_DIR/components/${ENTITY_PASCAL}Table.tsx"
import { DataTable } from "@/components/data-table";
import { use${ENTITY_PASCAL}Columns } from "../columns";

export const ${ENTITY_PASCAL}Table = ({ onEdit, onDelete }: any) => {
  const columns = use${ENTITY_PASCAL}Columns({ onEdit, onDelete });

  return (
    <DataTable 
      columns={columns} 
      data={[]} 
      isLoading={false}
    />
  );
};
EOF

cat <<EOF > "$BASE_DIR/components/${ENTITY_PASCAL}Form.tsx"
import { Sheet, SheetContent, SheetTitle } from "@/components";

export const ${ENTITY_PASCAL}Form = ({ isOpened, onClose }: any) => {
  return (
    <Sheet open={isOpened} onOpenChange={onClose}>
      <SheetContent>
        <SheetTitle>Manage ${ENTITY_PASCAL}</SheetTitle>
      </SheetContent>
    </Sheet>
  );
};
EOF
echo "export * from \"./${ENTITY_PASCAL}Form\";" > "$BASE_DIR/components/index.ts"
echo "export * from \"./${ENTITY_PASCAL}Table\";" >> "$BASE_DIR/components/index.ts"

# --- 7. PAGES ---
cat <<EOF > "$BASE_DIR/pages/${ENTITY_PASCAL}Page.tsx"
import { PageLayout } from "@/components";
import { TITLES } from "@/lib/constants";
import { ${ENTITY_PASCAL}Table } from "../components";

export const ${ENTITY_PASCAL}Page = () => {
  return (
    <PageLayout title={TITLES.MANAGE_${ENTITY_UPPER}}>
      <${ENTITY_PASCAL}Table onEdit={() => {}} onDelete={() => {}} />
    </PageLayout>
  );
};
EOF
echo "export * from \"./${ENTITY_PASCAL}Page\";" > "$BASE_DIR/pages/index.ts"

# --- 8. ROOT INDEX ---
cat <<EOF > "$BASE_DIR/index.ts"
export * from "./columns";
export * from "./components";
export * from "./constants";
export * from "./hooks";
export * from "./$ENTITY_KEBAB.api";
export * from "./pages";
export * from "./types";
EOF

echo "Structure generated! Types, API, and hooks are empty and ready for your custom code."