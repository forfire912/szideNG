/**
 * 项目模板生成器
 * 用于创建 STM32 和 ADSP 项目
 */

const fs = require('fs');
const path = require('path');
const vscode = require('vscode');

class ProjectTemplateManager {
    constructor() {
        this.templateBasePath = path.join(__dirname, '../../templates');
    }

    /**
     * 显示新建项目向导
     */
    async showNewProjectWizard() {
        // 选择项目类型
        const projectType = await vscode.window.showQuickPick([
            {
                label: '$(chip) STM32F429BIT6 工程',
                description: 'ARM Cortex-M4F 嵌入式项目',
                detail: '基于 STM32F429BIT6 的嵌入式开发项目',
                value: 'stm32'
            },
            {
                label: '$(circuit-board) ADSP-SC834/SC834W 工程',
                description: 'SHARC+ DSP 信号处理项目',
                detail: '基于 ADI ADSP-SC834/SC834W 的数字信号处理项目',
                value: 'adsp'
            }
        ], {
            placeHolder: '选择项目类型',
            title: '新建项目 - 步骤 1/4'
        });

        if (!projectType) return;

        // 输入项目名称
        const projectName = await vscode.window.showInputBox({
            prompt: '输入项目名称',
            placeHolder: '例如: MyProject',
            title: '新建项目 - 步骤 2/4',
            validateInput: (value) => {
                if (!value) return '项目名称不能为空';
                if (!/^[a-zA-Z0-9_-]+$/.test(value)) {
                    return '项目名称只能包含字母、数字、下划线和连字符';
                }
                return null;
            }
        });

        if (!projectName) return;

        // 选择项目位置
        const projectLocation = await vscode.window.showOpenDialog({
            canSelectFiles: false,
            canSelectFolders: true,
            canSelectMany: false,
            title: '新建项目 - 步骤 3/4: 选择项目位置',
            openLabel: '选择文件夹'
        });

        if (!projectLocation || projectLocation.length === 0) return;

        // 选择项目模板
        const templates = this.getAvailableTemplates(projectType.value);
        const selectedTemplate = await vscode.window.showQuickPick(templates, {
            placeHolder: '选择项目模板',
            title: '新建项目 - 步骤 4/4'
        });

        if (!selectedTemplate) return;

        // 创建项目
        const projectPath = path.join(projectLocation[0].fsPath, projectName);
        await this.createProject(projectType.value, projectName, projectPath, selectedTemplate.value);
    }

    /**
     * 获取可用模板列表
     */
    getAvailableTemplates(projectType) {
        if (projectType === 'stm32') {
            return [
                {
                    label: '$(file-code) 基础模板',
                    description: '包含最小系统和 HAL 库',
                    detail: 'main.c + 启动文件 + 链接脚本',
                    value: 'basic'
                },
                {
                    label: '$(library) HAL 库模板',
                    description: '完整的 STM32 HAL 库支持',
                    detail: '包含所有 HAL 驱动和示例代码',
                    value: 'hal'
                },
                {
                    label: '$(zap) FreeRTOS 模板',
                    description: '集成 FreeRTOS 实时操作系统',
                    detail: '包含任务调度和示例',
                    value: 'freertos'
                }
            ];
        } else if (projectType === 'adsp') {
            return [
                {
                    label: '$(file-code) 基础模板',
                    description: '包含最小系统',
                    detail: 'main.c + 启动文件 + LDF',
                    value: 'basic'
                },
                {
                    label: '$(symbol-misc) DSP 算法模板',
                    description: '包含常用 DSP 算法',
                    detail: 'FFT, FIR, IIR 等算法示例',
                    value: 'dsp'
                },
                {
                    label: '$(broadcast) 音频处理模板',
                    description: 'SPORT 音频接口',
                    detail: '音频输入输出和处理',
                    value: 'audio'
                }
            ];
        }
        return [];
    }

    /**
     * 创建项目
     */
    async createProject(projectType, projectName, projectPath, templateType) {
        try {
            // 显示进度
            await vscode.window.withProgress({
                location: vscode.ProgressLocation.Notification,
                title: `正在创建项目: ${projectName}`,
                cancellable: false
            }, async (progress) => {
                progress.report({ increment: 0, message: '创建目录结构...' });
                
                // 创建项目目录
                if (!fs.existsSync(projectPath)) {
                    fs.mkdirSync(projectPath, { recursive: true });
                }

                progress.report({ increment: 20, message: '复制模板文件...' });
                
                // 复制模板文件
                const templatePath = path.join(this.templateBasePath, projectType);
                await this.copyTemplateFiles(templatePath, projectPath, projectName);

                progress.report({ increment: 40, message: '配置项目设置...' });
                
                // 更新项目配置
                await this.updateProjectConfig(projectPath, projectName, projectType);

                progress.report({ increment: 20, message: '创建构建配置...' });
                
                // 创建 .vscode 配置
                await this.createVSCodeConfig(projectPath, projectType);

                progress.report({ increment: 20, message: '完成!' });
            });

            // 打开项目
            const openProject = await vscode.window.showInformationMessage(
                `项目 "${projectName}" 创建成功!`,
                '打开项目',
                '稍后'
            );

            if (openProject === '打开项目') {
                const uri = vscode.Uri.file(projectPath);
                await vscode.commands.executeCommand('vscode.openFolder', uri, false);
            }

        } catch (error) {
            vscode.window.showErrorMessage(`创建项目失败: ${error.message}`);
        }
    }

    /**
     * 复制模板文件
     */
    async copyTemplateFiles(src, dest, projectName) {
        if (!fs.existsSync(dest)) {
            fs.mkdirSync(dest, { recursive: true });
        }

        const entries = fs.readdirSync(src, { withFileTypes: true });

        for (const entry of entries) {
            const srcPath = path.join(src, entry.name);
            const destPath = path.join(dest, entry.name);

            if (entry.isDirectory()) {
                await this.copyTemplateFiles(srcPath, destPath, projectName);
            } else {
                // 跳过 VSCode 配置文件，稍后单独处理
                if (entry.name.endsWith('.json') && srcPath.includes('.vscode')) {
                    continue;
                }
                
                let content = fs.readFileSync(srcPath, 'utf8');
                
                // 替换模板变量
                content = content.replace(/\$\{PROJECT_NAME\}/g, projectName);
                content = content.replace(/\$\{DATE\}/g, new Date().toISOString().split('T')[0]);
                
                fs.writeFileSync(destPath, content);
            }
        }
    }

    /**
     * 更新项目配置
     */
    async updateProjectConfig(projectPath, projectName, projectType) {
        const configPath = path.join(projectPath, 'project.json');
        
        if (fs.existsSync(configPath)) {
            const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
            config.name = projectName;
            config.createdDate = new Date().toISOString();
            
            fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
        }
    }

    /**
     * 创建 VSCode 配置
     */
    async createVSCodeConfig(projectPath, projectType) {
        const vscodeDir = path.join(projectPath, '.vscode');
        if (!fs.existsSync(vscodeDir)) {
            fs.mkdirSync(vscodeDir);
        }

        const templateDir = path.join(this.templateBasePath, projectType);
        
        // 复制 tasks.json
        const tasksTemplate = path.join(templateDir, 'tasks.json');
        if (fs.existsSync(tasksTemplate)) {
            fs.copyFileSync(tasksTemplate, path.join(vscodeDir, 'tasks.json'));
        }

        // 复制 launch.json
        const launchTemplate = path.join(templateDir, 'launch.json');
        if (fs.existsSync(launchTemplate)) {
            fs.copyFileSync(launchTemplate, path.join(vscodeDir, 'launch.json'));
        }

        // 复制 c_cpp_properties.json
        const cppPropsTemplate = path.join(templateDir, 'c_cpp_properties.json');
        if (fs.existsSync(cppPropsTemplate)) {
            fs.copyFileSync(cppPropsTemplate, path.join(vscodeDir, 'c_cpp_properties.json'));
        }
    }
}

module.exports = ProjectTemplateManager;
