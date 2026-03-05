#!/bin/bash
# check-plan.sh - Monitors LifeCostTracker PLAN.md for task completion

PLAN_FILE="/root/.openclaw/workspace/plan/LifeCostTracker/PLAN.md"
LAST_CHECK_FILE="/root/.openclaw/workspace/plan/LifeCostTracker/project-management/last-check.txt"
LOG_FILE="/root/.openclaw/workspace/plan/LifeCostTracker/project-management/plan-check.log"

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Create log and last check files if they don't exist
touch "$LOG_FILE"
touch "$LAST_CHECK_FILE"

# Get last modified time of PLAN.md
PLAN_MOD_TIME=$(stat -c %Y "$PLAN_FILE" 2>/dev/null || stat -f %m "$PLAN_FILE")
LAST_CHECK_TIME=$(cat "$LAST_CHECK_FILE" 2>/dev/null || echo 0)

# Check if PLAN.md has been modified since last check
if [ "$PLAN_MOD_TIME" -gt "$LAST_CHECK_TIME" ]; then
    log "PLAN.md has been modified. Checking for completed tasks..."
    
    # Count completed tasks (lines starting with - [x])
    COMPLETED_TASKS=$(grep -c "^- \[x\]" "$PLAN_FILE")
    TOTAL_TASKS=$(grep -c "^- \[ \|^- \[x\]" "$PLAN_FILE")
    
    log "Progress: $COMPLETED_TASKS/$TOTAL_TASKS tasks completed"
    
    # Update last check time
    echo "$PLAN_MOD_TIME" > "$LAST_CHECK_FILE"
    
    # Optional: Send notification (uncomment and configure if needed)
    # openclaw message send --message "LifeCostTracker Plan Update: $COMPLETED_TASKS/$TOTAL_TASKS tasks completed"
else
    log "PLAN.md not modified since last check"
fi
