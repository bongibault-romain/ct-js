/* eslint-disable camelcase */
const coreEvents = {
    // Basic, primitive events, aka lifecycle events
    core_OnCreate: {
        name: 'On Create',
        applicable: ['template'],
        icon: 'sun',
        category: {
            key: 'lifecycle',
            custom: false
        },
        codeTargets: ['thisOnCreate']
    },
    core_OnRoomStart: {
        name: 'On Room Start',
        applicable: ['room'],
        icon: 'sun',
        category: {
            key: 'lifecycle',
            custom: false
        },
        codeTargets: ['thisOnCreate']
    },
    core_OnStep: {
        name: 'On Step',
        applicable: ['template', 'room'],
        icon: 'skip-forward',
        category: {
            key: 'lifecycle',
            custom: false
        },
        codeTargets: ['thisOnStep']
    },
    core_OnDraw: {
        name: 'On Draw',
        applicable: ['template', 'room'],
        icon: 'edit-2',
        category: {
            key: 'lifecycle',
            custom: false
        },
        codeTargets: ['thisOnDraw']
    },
    core_OnDestroy: {
        name: 'On Destroy',
        applicable: ['template'],
        icon: 'trash',
        category: {
            key: 'lifecycle',
            custom: false
        },
        codeTargets: ['thisOnDestroy']
    },
    core_OnRoomEnd: {
        name: 'On Room End',
        applicable: ['room'],
        icon: 'trash',
        category: {
            key: 'lifecycle',
            custom: false
        },
        codeTargets: ['thisOnDestroy']
    }
} as Record<string, IEventDeclaration>;

export = coreEvents;

