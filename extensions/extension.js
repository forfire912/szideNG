/**
 * szideNG 扩展主文件
 */

const vscode = require('vscode');
const ProjectTemplateManager = require('./project-template-manager');

let templateManager;

/**
 * 扩展激活时调用
 */
function activate(context) {
    console.log('szideNG 扩展已激活');

    templateManager = new ProjectTemplateManager();

    // 注册命令: 新建项目
    let newProjectCmd = vscode.commands.registerCommand('szide.newProject', async () => {
        await templateManager.showNewProjectWizard();
    });

    // 注册命令: 构建项目
    let buildProjectCmd = vscode.commands.registerCommand('szide.buildProject', async () => {
        await buildCurrentProject();
    });

    // 注册命令: 清理项目
    let cleanProjectCmd = vscode.commands.registerCommand('szide.cleanProject', async () => {
        await cleanCurrentProject();
    });

    // 注册命令: 反汇编
    let disassembleCmd = vscode.commands.registerCommand('szide.disassemble', async () => {
        await disassembleCurrentFile();
    });

    // 注册命令: 烧录设备
    let flashDeviceCmd = vscode.commands.registerCommand('szide.flashDevice', async () => {
        await flashToDevice();
    });

    context.subscriptions.push(
        newProjectCmd,
        buildProjectCmd,
        cleanProjectCmd,
        disassembleCmd,
        flashDeviceCmd
    );

    // 显示欢迎消息
    showWelcomeMessage();
}

/**
 * 构建当前项目
 */
async function buildCurrentProject() {
    const config = vscode.workspace.getConfiguration('szide');
    
    if (config.get('autoSaveBeforeBuild')) {
        await vscode.workspace.saveAll();
    }

    // 执行构建任务
    const tasks = await vscode.tasks.fetchTasks();
    const buildTask = tasks.find(t => t.name.includes('Build') || t.group?.isDefault);

    if (buildTask) {
        await vscode.tasks.executeTask(buildTask);
        
        if (config.get('showBuildNotifications')) {
            vscode.window.showInformationMessage('正在构建项目...');
        }
    } else {
        vscode.window.showErrorMessage('未找到构建任务，请检查 tasks.json 配置');
    }
}

/**
 * 清理当前项目
 */
async function cleanCurrentProject() {
    const tasks = await vscode.tasks.fetchTasks();
    const cleanTask = tasks.find(t => t.name.includes('Clean'));

    if (cleanTask) {
        await vscode.tasks.executeTask(cleanTask);
        vscode.window.showInformationMessage('正在清理项目...');
    } else {
        vscode.window.showWarningMessage('未找到清理任务');
    }
}

/**
 * 反汇编当前文件
 */
async function disassembleCurrentFile() {
    const editor = vscode.window.activeTextEditor;
    
    if (!editor) {
        vscode.window.showErrorMessage('请先打开一个文件');
        return;
    }

    const filePath = editor.document.uri.fsPath;
    
    if (!filePath.endsWith('.elf') && !filePath.endsWith('.dxe')) {
        vscode.window.showErrorMessage('只能反汇编 .elf 或 .dxe 文件');
        return;
    }

    // 执行反汇编任务
    const tasks = await vscode.tasks.fetchTasks();
    const disassembleTask = tasks.find(t => t.name.includes('Disassemble'));

    if (disassembleTask) {
        await vscode.tasks.executeTask(disassembleTask);
        vscode.window.showInformationMessage('正在反汇编...');
    } else {
        vscode.window.showErrorMessage('未找到反汇编任务');
    }
}

/**
 * 烧录到设备
 */
async function flashToDevice() {
    const choice = await vscode.window.showQuickPick([
        { label: '$(debug-disconnect) ST-Link', value: 'stlink' },
        { label: '$(debug-disconnect) J-Link', value: 'jlink' },
        { label: '$(debug-disconnect) OpenOCD', value: 'openocd' },
        { label: '$(debug-disconnect) ADI ICE', value: 'ice' }
    ], {
        placeHolder: '选择烧录工具'
    });

    if (choice) {
        vscode.window.showInformationMessage(`正在使用 ${choice.label} 烧录设备...`);
        // 实际的烧录逻辑需要根据具体工具实现
    }
}

/**
 * 显示欢迎消息
 */
function showWelcomeMessage() {
    const config = vscode.workspace.getConfiguration('szide');
    const hasShownWelcome = context.globalState.get('hasShownWelcome', false);

    if (!hasShownWelcome) {
        vscode.window.showInformationMessage(
            '欢迎使用 专用芯片嵌入式软件IDE！',
            '创建新项目',
            '查看文档'
        ).then(selection => {
            if (selection === '创建新项目') {
                vscode.commands.executeCommand('szide.newProject');
            } else if (selection === '查看文档') {
                vscode.env.openExternal(vscode.Uri.parse('https://your-docs-url.com'));
            }
        });

        context.globalState.update('hasShownWelcome', true);
    }
}

/**
 * 扩展停用时调用
 */
function deactivate() {
    console.log('szideNG 扩展已停用');
}

module.exports = {
    activate,
    deactivate
};
