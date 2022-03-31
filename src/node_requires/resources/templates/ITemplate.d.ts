interface ITemplate extends IScriptable {
    depth: number,
    texture: assetRef,
    visible: boolean,
    extends: {
        [key: string]: unknown
    }
}
