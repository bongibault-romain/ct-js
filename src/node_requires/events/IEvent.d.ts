declare interface IEventCategory {
    name: string;
    hint?: string;
    icon: string;
    [key: string]: string;
}

type EventApplicableEntities = 'template' | 'room';
type EventArgumentTypes =
    'integer' | 'float' | 'string' | 'boolean' |
    'template' | 'room' | 'sound' | 'tandem' | 'font' | 'style' | 'texture' | 'action';
type EventCodeTargets =
    'thisOnStep' | 'thisOnCreate' | 'thisOnDraw' | 'thisOnDestroy' |
    'rootRoomOnCreate' | 'rootRoomOnStep' | 'rootRoomOnDraw' | 'rootRoomOnLeave';

declare interface IEventArgumentDeclaration {
    name: string;
    type: EventArgumentTypes;
    default?: unknown;
}

declare interface IEventDeclaration {
    name: string;
    hint?: string;
    applicable: EventApplicableEntities[];
    icon: string;
    category: {
        key: string;
        custom: boolean;
    };
    arguments?: {
        [key: string]: IEventArgumentDeclaration;
    };
    locals?: {
        [key: string]: string;
    };
    codeTargets: EventCodeTargets[];
}
