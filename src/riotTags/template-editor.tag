template-editor.aPanel.aView.flexrow
    .template-editor-Properties
        .tall.flexfix.aPanel.pad
            .flexfix-header
                asset-input.wide(
                    assettype="textures"
                    assetid="{template.texture || -1}"
                    large="large"
                    allowclear="allowclear"
                    onchanged="{applyTexture}"
                )
                .aSpacer
            .flexfix-body
                event-list-scriptable(
                    events="{template.events}"
                    entitytype="template"
                    onchanged="{changeCodeTab}"
                    currentevent="{currentSheet}"
                ).tall
            .flexfix-footer
                .aSpacer
                button#templatedone.wide(onclick="{templateSave}" title="Shift+Control+S" data-hotkey="Control+S")
                    svg.feather
                        use(xlink:href="#check")
                    span {voc.done}
    .template-editor-aCodeEditor
        .tabwrap.tall(style="position: relative")
            //ul.tabs.aNav.nogrow.noshrink
            //    li(onclick="{changeTab('javascript')}" class="{active: tab === 'javascript'}" title="JavaScript (Control+Q)" data-hotkey="Control+q")
            //        svg.feather
            //            use(xlink:href="#code")
            //        span {voc.create}
            //    li(onclick="{changeTab('blocks')}" class="{active: tab === 'blocks'}" title="Blurry (Control+W)" data-hotkey="Control+w")
            //        svg.feather
            //            use(xlink:href="#grid")
            //        span {voc.step}
            div
                .tabbed(show="{tab === 'javascript'}")
                    code-editor-scriptable(event="{currentSheet}" entitytype="template")
                // .tabbed(show="{tab === 'blocks'}")
                //     .aBlocksEditor(ref="blocks")
    .template-editor-Properties
        .tall.flexfix.aPanel.pad
            .flexfix-body
                fieldset
                    label.block
                        b {voc.name}
                        input.wide(type="text" onchange="{wire('this.template.name')}" value="{template.name}")
                        .anErrorNotice(if="{nameTaken}" ref="errorNotice") {vocGlob.nameTaken}
                collapsible-section.aPanel(
                    heading="{voc.appearance}"
                    storestatekey="templateEditorAppearance"
                    hlevel="4"
                )
                    fieldset
                        label.block
                            b {parent.voc.depth}
                            input.wide(
                                type="number"
                                onchange="{parent.wire('this.template.depth')}"
                                value="{parent.template.depth}"
                            )
                        label.block
                            b {parent.voc.opacity}
                            input.wide(
                                type="number" min="0" max="1" step="0.1"
                                onchange="{parent.wire('this.template.extends.alpha')}"
                                value="{parent.template.extends.alpha ?? 1}"
                            )
                        label.block
                            b {parent.voc.blendMode}
                            select.wide(onchange="{parent.wire('this.template.blendMode')}")
                                option(value="normal" selected="{parent.template.blendMode === 'normal' || !parent.template.blendMode}") {parent.voc.blendModes.normal}
                                option(value="add" selected="{parent.template.blendMode === 'add'}") {parent.voc.blendModes.add}
                                option(value="multiply" selected="{parent.template.blendMode === 'multiply'}") {parent.voc.blendModes.multiply}
                                option(value="screen" selected="{parent.template.blendMode === 'screen'}") {parent.voc.blendModes.screen}
                    fieldset
                        label.block.checkbox
                            input(type="checkbox" checked="{parent.template.playAnimationOnStart}" onchange="{parent.wire('this.template.playAnimationOnStart')}")
                            span {parent.voc.playAnimationOnStart}
                        label.block.checkbox
                            input(type="checkbox" checked="{parent.template.extends.visible ?? true}" onchange="{parent.wire('this.template.extends.visible')}")
                            span {parent.voc.visible}
                .aSpacer
                extensions-editor(type="template" entity="{template.extends}" wide="yep" compact="probably")
    script.
        const glob = require('./data/node_requires/glob');
        this.glob = glob;
        this.namespace = 'templateView';
        this.mixin(window.riotVoc);
        this.mixin(window.riotWired);

        const textures = require('./data/node_requires/resources/textures');

        this.getTextureRevision = template => textures.getById(template.texture).lastmod;

        this.template = this.opts.template;
        this.tab = 'javascript';
        this.currentSheet = this.template.events[0]; // can be undefined, this is ok

        this.changeTab = tab => () => {
            this.tab = tab;
            if (this.tab === 'javascript') {
                setTimeout(() => {
                    this.codeEditor.layout();
                    this.codeEditor.focus();
                }, 0);
            }
        };

        const updateEditorSize = () => {
            if (this.tab === 'javascript') {
                this.codeEditor.layout();
            }
        };
        const updateEditorSizeDeferred = function () {
            setTimeout(updateEditorSize, 0);
        };
        window.signals.on('templatesFocus', this.focusEditor);
        window.signals.on('templatesFocus', updateEditorSizeDeferred);
        window.addEventListener('resize', updateEditorSize);
        this.on('unmount', () => {
            window.signals.off('templatesFocus', this.focusEditor);
            window.signals.off('templatesFocus', updateEditorSizeDeferred);
            window.removeEventListener('resize', updateEditorSize);
        });

        this.on('mount', () => {
            var editorOptions = {
                language: 'typescript',
                lockWrapper: true
            };
            setTimeout(() => {
                this.codeEditor = window.setupCodeEditor(
                    this.refs.javascript,
                    Object.assign({}, editorOptions, {
                        value: '',
                        wrapper: ['function onCreate(this: Copy) {', '}']
                    })
                );

                this.codeEditor.onDidChangeModelContent(() => {
                    this.currentEvent.code = this.codeEditor.getPureValue();
                });
                this.codeEditor.focus();
            }, 0);
        });
        this.checkNames = () => {
            if (global.currentProject.templates.find(template =>
                this.template.name === template.name && this.template !== template)) {
                this.nameTaken = true;
            } else {
                this.nameTaken = false;
            }
        };
        this.on('update', () => {
            this.checkNames();
        });

        this.changeSprite = () => {
            this.selectingTexture = true;
        };
        this.applyTexture = texture => {
            // eslint-disable-next-line eqeqeq
            if (texture == -1) {
                this.template.texture = -1;
            } else {
                this.template.texture = texture;
                if (this.template.name === 'NewTemplate') {
                    this.template.name = textures.getById(texture).name;
                }
            }
            this.selectingTexture = false;
            this.parent.fillTemplateMap();
            this.update();
        };
        this.cancelTexture = () => {
            this.selectingTexture = false;
            this.update();
        };
        this.templateSave = () => {
            this.checkNames();
            if (this.nameTaken) {
                this.update();
                // animate the error notice
                require('./data/node_requires/jellify')(this.refs.errorNotice);
                if (localStorage.disableSounds !== 'on') {
                    soundbox.play('Failure');
                }
                return false;
            }
            glob.modified = true;
            this.template.lastmod = Number(new Date());
            this.parent.editingTemplate = false;
            this.parent.fillTemplateMap();
            this.parent.update();
            window.signals.trigger('templatesChanged');
            return true;
        };
        this.changeCodeTab = scriptableEvent => {
            this.currentSheet = scriptableEvent;
        };
